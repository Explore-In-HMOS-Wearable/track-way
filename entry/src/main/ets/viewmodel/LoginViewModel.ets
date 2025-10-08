import { authentication } from '@kit.AccountKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';

const LOG_DOMAIN = 0x0001;
const TAG = '[LoginViewModel]';

interface User {
  openId: string;
  unionId: string;
}

@Observed
export class LoginViewModel {
  isLoggedIn: boolean = false;
  user: User | null = null;
  statusMessage: string = 'Log In.';
  username: string = '';
  password: string = '';

  public onLoginSuccess: () => void = () => {
  };

  signInWithUsername() {
    if (this.username === 'user' && this.password === '1234') {
      this.isLoggedIn = true;
      this.statusMessage = `Welcome, ${this.username}!`;
      hilog.info(LOG_DOMAIN, TAG, 'Mock user login successful.');
      this.onLoginSuccess();
    } else {
      this.isLoggedIn = false;
      this.statusMessage = 'Incorrect username or password.';
      hilog.error(LOG_DOMAIN, TAG, 'Mock user login failed.');
    }
  }

  async signInWithHuaweiID(context: common.Context) {
    this.statusMessage = "Logging in...";

    try {
      const huaweiIdProvider = new authentication.HuaweiIDProvider();
      const authRequest = huaweiIdProvider.createAuthorizationWithHuaweiIDRequest();
      authRequest.scopes = ['openid'];
      authRequest.permissions = ['idtoken'];

      const controller = new authentication.AuthenticationController(context);
      const genericResponse = await controller.executeRequest(authRequest);
      const authResponse = genericResponse as authentication.AuthorizationWithHuaweiIDResponse;
      const credential = authResponse.data;

      if (credential && credential.openID && credential.unionID) {
        this.isLoggedIn = true;
        this.user = {
          openId: credential.openID,
          unionId: credential.unionID
        };
        this.statusMessage = `Success!\nOpenID: ${this.user.openId.substring(0, 10)}...`;
        hilog.info(LOG_DOMAIN, TAG, 'Success. OpenID: %s', this.user.openId);
        this.onLoginSuccess();
      } else {
        throw new Error('Could not retrieve ID information.');
      }
    } catch (error) {
      const businessError = error as BusinessError;
      this.isLoggedIn = false;
      this.user = null;

      if (businessError.code === 1001502012) {
        this.statusMessage = 'Cancelled.';
      } else {
        this.statusMessage = `Error: ${businessError.message} (Code: ${businessError.code})`;
      }
      hilog.error(LOG_DOMAIN, TAG, this.statusMessage);
    }
  }
}