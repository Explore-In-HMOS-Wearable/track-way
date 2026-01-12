import { Trip } from '../model/Trip';

@Component
export struct HomePage {
  private upcomingTrip: Trip = new Trip(1, 'Istanbul', 'Ankara', new Date().getTime(), 'Train');

  @Consume('pageInfos') pageInfos: NavPathStack;

  @Builder CustomTitle() {
    Row() {
      Text('Trip Planner')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .margin({ top: '10%' })
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    NavDestination() {
      Scroll() {
        Grid() {
          GridItem() {
            this.WeatherWidget(25, 'Sunny')
          }
          .onClick(() => {
            console.info('Weather widget clicked');
          })
          .shadow({ radius: 15, color: 'rgba(0,0,0,0.3)', offsetX: 4, offsetY: 8 })

          GridItem() {
            this.MapWidget()
          }
          .onClick(() => {
            this.pageInfos.pushPath({ name: 'MapPage' });
          })
          .shadow({ radius: 15, color: 'rgba(0,0,0,0.3)', offsetX: 4, offsetY: 8 })

          GridItem() {
            this.TripWidget(this.upcomingTrip)
          }
          .onClick(() => {
            this.pageInfos.pushPath({ name: 'TripLoggerPage' });
          })
          .shadow({ radius: 15, color: 'rgba(0,0,0,0.3)', offsetX: 4, offsetY: 8 })

          GridItem() {
            this.QrCodeWidget()
          }
          .onClick(() => {
            this.pageInfos.pushPath({ name: 'PnrPage' });
          })
          .shadow({ radius: 15, color: 'rgba(0,0,0,0.3)', offsetX: 4, offsetY: 8 })
        }
        .columnsTemplate('1fr 1fr')
        .rowsTemplate('1fr 1fr')
        .columnsGap(15)
        .rowsGap(15)
        .padding(20)
        .width('100%')
      }
      .width('100%')
      .height('100%')
    }
    .title(this.CustomTitle())
    .hideBackButton(true)
    .backgroundColor(Color.Black)
  }

  @Builder WeatherWidget(temperature: number, description: string) {
    Column({ space: 4 }) {
      Image($r('app.media.icobWeather')).width(32).height(32).objectFit(ImageFit.Contain)
      Text(`${temperature}°C`).fontSize(20).fontWeight(FontWeight.Bold).fontColor(Color.White)
      Text(description).fontSize(11).fontColor('rgba(255,255,255,0.7)')
    }
    .width('100%').height('100%').justifyContent(FlexAlign.Center)
    .backgroundColor(0x3B0270)
    .borderRadius(20)
  }

  @Builder MapWidget() {
    Column({ space: 4 }) {
      Image($r('app.media.iconMap')).width(32).height(32).objectFit(ImageFit.Contain)
      Text('Show Map').fontSize(14).fontColor(Color.White)
    }
    .width('100%').height('100%').justifyContent(FlexAlign.Center)
    .backgroundColor(0x3A6F43)
    .borderRadius(20)
  }

  @Builder TripWidget(trip: Trip) {
    Column({ space: 2 }) {
      Text('Next Trip').fontSize(10).fontColor('rgba(255,255,255,0.7)')
      Text(`${trip.from} → ${trip.to}`)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .maxLines(1)

      Text(new Date(trip.startTime).toLocaleDateString())
        .fontSize(11)
        .fontColor('rgba(255,255,255,0.7)')
    }
    .padding(10).width('100%').height('100%').justifyContent(FlexAlign.Center)
    .backgroundColor(0x6B3F69)
    .borderRadius(20)
  }

  @Builder QrCodeWidget() {
    Column({ space: 4 }) {
      Image($r('app.media.iconQR')).width(32).height(32).objectFit(ImageFit.Contain)
      Text('PNR to QR').fontSize(14).fontColor(Color.White)
    }
    .width('100%').height('100%').justifyContent(FlexAlign.Center)
    .backgroundColor(0x541212)
    .borderRadius(20)
  }
}

@Entry
@Component
struct HomePageEntry {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageInfos) {
      HomePage()
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .backgroundColor(Color.Black)
  }
}