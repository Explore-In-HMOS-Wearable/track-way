
import { LoginViewModel } from '../viewmodel/LoginViewModel';
import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, ColorMetrics } from '@kit.ArkUI';
import router from '@ohos.router';

@Entry
@Component
struct LoginPage {
  @State private viewModel: LoginViewModel = new LoginViewModel();

  private huaweiIdButtonOptions: ArcButtonOptions = new ArcButtonOptions({
    label: 'Huawei ID',
    position: ArcButtonPosition.BOTTOM_EDGE,
    styleMode: ArcButtonStyleMode.CUSTOM,
    backgroundColor: ColorMetrics.numeric(0xFF8C1007),
  });

  aboutToAppear() {
    this.viewModel.onLoginSuccess = () => {
      console.info('Sucsessfull entered! Routing...');
      router.replaceUrl({
        url: 'pages/HomePage'
      });
    };

    this.huaweiIdButtonOptions.onClick = () => {
      this.viewModel.signInWithHuaweiID(getContext(this));
    };
  }

  build() {
    Stack() {
      Scroll() {
        Column() {
          Text('TrackWay')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .margin({ top: '10%', bottom: '10%' })

          if (!this.viewModel.isLoggedIn) {
            Column({ space: 10 }) {
              TextInput({ placeholder: 'Username', text: this.viewModel.username })
                .onChange((value: string) => { this.viewModel.username = value; })
                .width('80%')
                .padding({ left: 15, right: 15 })

              TextInput({ placeholder: 'Password', text: this.viewModel.password })
                .type(InputType.Password)
                .onChange((value: string) => { this.viewModel.password = value; })
                .width('80%')
                .padding({ left: 15, right: 15 })

              Button('Log In')
                .width('80%')
                .height(50)
                .fontSize(18)
                .margin({ top: 10 })
                .onClick(() => { this.viewModel.signInWithUsername(); })
            }
            .alignItems(HorizontalAlign.Center)
            Text("OR")
            if (!this.viewModel.isLoggedIn) {
              ArcButton({ options: this.huaweiIdButtonOptions })
            }

          } else {
            Column({space: 15}) {
              LoadingProgress().width(50).color(Color.White)
              Text('Entered, routing...')
                .fontColor(Color.White)
            }
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)

    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
  }
}