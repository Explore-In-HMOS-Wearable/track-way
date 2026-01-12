import { TripViewModel } from '../viewmodel/TripViewModel';
import { Trip } from '../model/Trip';

@Component
export struct TripLoggerPage {
  @State viewModel: TripViewModel = new TripViewModel();

  @Consume('pageInfos') pageInfos: NavPathStack;

  aboutToAppear() {
    this.viewModel.loadTrips();
  }

  build() {
    NavDestination() {
      Scroll() {
        Column({ space: 10 }) {

          // --- Header ---
          Row({ space: 10 }) {
            Image($r('app.media.iconBack'))
              .width(24)
              .height(24)
              .fillColor(Color.White)
              .objectFit(ImageFit.Contain)

            Text('New Trip')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
          .width('100%')
          .padding({ top: 15, bottom: 5 })
          .onClick(() => {
            this.pageInfos.pop();
          })

          // --- Inputs ---
          TextInput({ text: this.viewModel.fromLocation, placeholder: 'From?' })
            .onChange((value) => {
              this.viewModel.fromLocation = value;
            })
            .backgroundColor(Color.White)
            .width('100%')

          TextInput({ text: this.viewModel.toLocation, placeholder: 'To?' })
            .onChange((value) => {
              this.viewModel.toLocation = value;
            })
            .backgroundColor(Color.White)
            .width('100%')

          // --- Radios ---
          Row({ space: 5 }) {
            Radio({ value: 'Train', group: 'transportGroup' })
              .checked(this.viewModel.transportType === 'Train')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.viewModel.transportType = 'Train';
                }
              })
            Text('Train').fontColor(Color.White).fontSize(14)

            Radio({ value: 'Bus', group: 'transportGroup' })
              .checked(this.viewModel.transportType === 'Bus')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.viewModel.transportType = 'Bus';
                }
              })
            Text('Bus').fontColor(Color.White).fontSize(14)

            Radio({ value: 'Plane', group: 'transportGroup' })
              .checked(this.viewModel.transportType === 'Plane')
              .onChange((isChecked: boolean) => {
                if (isChecked) {
                  this.viewModel.transportType = 'Plane';
                }
              })
            Text('Plane').fontColor(Color.White).fontSize(14)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceAround)
          .padding({ top: 10, bottom: 10 })

          // --- DatePicker ---
          Column() {
            DatePicker({
              start: new Date('2020-01-01'),
              end: new Date('2030-12-31'),
              selected: this.viewModel.selectedDate
            })
              .onDateChange((value: Date) => {
                this.viewModel.selectedDate = value;
              })
              .height(150)
          }
          .backgroundColor(Color.White)
          .borderRadius(10)
          .width('100%')

          // --- Save Button ---
          Button('Save Trip')
            .onClick(() => {
              this.viewModel.saveTrip();
            })
            .width('100%')
            .margin({ top: 15 })

          // --- Status Message ---
          if (this.viewModel.operationMessage) {
            Text(this.viewModel.operationMessage)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.viewModel.isError ? Color.Red : Color.Green)
              .margin({ top: 5 })
              .textAlign(TextAlign.Center)
              .width('100%')
          }

          Divider().margin({ top: 15, bottom: 10 }).color(Color.Gray)

          // --- Saved List ---
          Text('Saved Trips').fontSize(18).fontWeight(FontWeight.Medium).fontColor(Color.White)

          if (this.viewModel.savedTrips.length > 0) {
            List({ space: 8 }) {
              ForEach(this.viewModel.savedTrips, (trip: Trip) => {
                ListItem() {
                  Column({ space: 5 }) {
                    Text(`Trip: ${trip.from} -> ${trip.to}`)
                      .fontSize(16)
                      .fontWeight(FontWeight.Bold)
                      .fontColor(Color.White)

                    Text(`${new Date(trip.startTime).toLocaleDateString()} - ${trip.transportType}`)
                      .fontSize(14)
                      .fontColor(Color.Gray)
                  }
                  .width('100%')
                  .alignItems(HorizontalAlign.Start)
                  .padding(10)
                  .border({ width: 1, color: Color.Gray, radius: 8 })
                }
              }, (trip: Trip) => trip.id.toString())
            }
            .width('100%')
            .height('30%')
          } else {
            Text('No saved trips yet.').fontColor(Color.Gray).margin({ top: 20 })
          }
        }
        .width('90%')
        .padding(15)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Black)
    }
    .hideTitleBar(true)
  }
}

// Entry Wrapper
@Entry
@Component
struct TripLoggerPageEntry {
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageInfos) {
      TripLoggerPage()
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .backgroundColor(Color.Black)
  }
}