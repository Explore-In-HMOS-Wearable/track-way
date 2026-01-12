import { LoginViewModel } from '../viewmodel/LoginViewModel';
import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, ColorMetrics } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { HomePage } from './HomePage';
import { MapPage } from './MapPage';
import { PnrPage } from './PnrPage';
import { TripLoggerPage } from './TripLoggerPage';

@Entry
@Component
export struct LoginPage {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  @State private viewModel: LoginViewModel = new LoginViewModel();

  private huaweiIdButtonOptions: ArcButtonOptions = new ArcButtonOptions({
    label: 'Huawei ID',
    position: ArcButtonPosition.BOTTOM_EDGE,
    styleMode: ArcButtonStyleMode.CUSTOM,
    backgroundColor: ColorMetrics.numeric(0xFF8C1007)
  });

  aboutToAppear() {
    this.viewModel.onLoginSuccess = () => {
      console.info('Successfull entered! Routing...');
      this.pageInfos.pushPath({ name: 'BillsPage' });
    };

    this.huaweiIdButtonOptions.onClick = () => {
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      this.viewModel.signInWithHuaweiID(context);
    };
  }

  @Builder
  PageMap(name: string) {
    if (name === 'BillsPage' || name === 'HomePage') {
      HomePage()
    }
    else if (name === 'MapPage') {
      MapPage()
    }
    else if (name === 'TripLoggerPage') {
      TripLoggerPage()
    }
    else if (name === 'PnrPage') {
      PnrPage()
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Stack() {
        Scroll() {
          Column() {
            Text('TrackWay')
              .fontSize(28)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .margin({ top: '10%', bottom: '10%' })

            if (!this.viewModel.isLoggedIn) {
              Column({ space: 10 }) {
                TextInput({ placeholder: 'Username', text: this.viewModel.username })
                  .onChange((value: string) => {
                    this.viewModel.username = value;
                  })
                  .width('80%')
                  .padding({ left: 15, right: 15 })
                  .backgroundColor(Color.White)

                TextInput({ placeholder: 'Password', text: this.viewModel.password })
                  .type(InputType.Password)
                  .onChange((value: string) => {
                    this.viewModel.password = value;
                  })
                  .width('80%')
                  .padding({ left: 15, right: 15 })
                  .backgroundColor(Color.White)

                Button('Log In')
                  .width('80%')
                  .height(50)
                  .fontSize(18)
                  .margin({ top: 10 })
                  .onClick(() => {
                    this.viewModel.signInWithUsername();
                  })
              }
              .alignItems(HorizontalAlign.Center)

              Text('OR')
                .fontColor(Color.Gray)
                .margin({ top: 10, bottom: 10 })

              if (!this.viewModel.isLoggedIn) {
                ArcButton({ options: this.huaweiIdButtonOptions })
              }

            } else {
              Column({ space: 15 }) {
                LoadingProgress().width(50).color(Color.White)
                Text('Entered, routing...')
                  .fontColor(Color.White)
              }
            }
          }
          .width('100%')
          .constraintSize({ minHeight: '100%' })
          .justifyContent(FlexAlign.Center)
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
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PageMap)
  }
}