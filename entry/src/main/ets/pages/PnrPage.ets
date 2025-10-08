import { PNRViewModel } from '../viewmodel/PNRViewModel';
import { router } from '@kit.ArkUI';

@Entry
@Component
export struct PnrPage {
  @State private viewModel: PNRViewModel = new PNRViewModel();

  build() {
    Scroll(){
      Column({ space: 15 }) {
        Row({ space: 10 }) {
          Image($r('app.media.iconBack'))
            .width(24)
            .height(24)
            .fillColor(Color.White)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back();
            })

          Text('Enter PNR')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
        }

        TextInput({ placeholder: 'Enter PNR', text: this.viewModel.pnrNumber })
          .onChange((value: string) => {
            this.viewModel.pnrNumber = value;
          })
          .width('90%')
          .height(40)
          .fontSize(16)

        Button('QR Code')
          .width('90%')
          .height(45)
          .onClick(() => {
            this.viewModel.generateQrCode();
          })
          .enabled(!this.viewModel.isLoading)

        this.StatusArea()

      }

      .padding(20)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(0x1C1C1E)
    }.scrollable(ScrollDirection.Vertical)


  }
  @Builder
StatusArea() {
  if (this.viewModel.isLoading) {
    LoadingProgress()
      .width(50)
      .height(50)
      .color(Color.White)
  } else if (this.viewModel.errorMessage) {
    Text(this.viewModel.errorMessage)
      .fontColor(Color.Red)
      .fontSize(14)
      .textAlign(TextAlign.Center)
      .margin(10)
  } else if (this.viewModel.qrCodeImage) {
    Image(this.viewModel.qrCodeImage)
      .width(180)
      .height(180)
      .objectFit(ImageFit.Contain)
      .borderRadius(10)
  } else {
    Text('QR Code Will be display here.')
      .fontColor(Color.Gray)
      .fontSize(14)
      .margin(10)
  }
  }
}