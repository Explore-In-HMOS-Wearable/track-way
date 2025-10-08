import router from '@ohos.router';
import { TripViewModel } from '../viewmodel/TripViewModel';
import { Trip } from '../model/Trip';

@Entry
@ComponentV2
export struct TripLoggerPage {
  @Local viewModel: TripViewModel = new TripViewModel();

  aboutToAppear() {
    this.viewModel.loadTrips();
  }

  build() {
    Scroll() {
      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Image($r('app.media.iconBack'))
            .width(24)
            .height(24)
            .fillColor(Color.White)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.back();
            })

          Text('New Trip')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ top: 15, bottom: 5 })


        TextInput({ text: this.viewModel.fromLocation, placeholder: 'From?' })
          .onChange((value) => {
            this.viewModel.fromLocation = value;
          })

        TextInput({ text: this.viewModel.toLocation, placeholder: 'To?' })
          .onChange((value) => {
            this.viewModel.toLocation = value;
          })

        Row({ space: 1 }) {
          Radio({ value: 'Train', group: 'transportGroup' })
            .checked(this.viewModel.transportType === 'Train')
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.viewModel.transportType = 'Train';
              }
            })
          Text('Train').fontColor(Color.White)

          Radio({ value: 'Bus', group: 'transportGroup' })
            .checked(this.viewModel.transportType === 'Bus')
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.viewModel.transportType = 'Bus';
              }
            })
          Text('Bus').fontColor(Color.White)

          Radio({ value: 'Plane', group: 'transportGroup' })
            .checked(this.viewModel.transportType === 'Plane')
            .onChange((isChecked: boolean) => {
              if (isChecked) {
                this.viewModel.transportType = 'Plane';
              }
            })
          Text('Plane').fontColor(Color.White)
        }.width('100%').justifyContent(FlexAlign.Center)

        DatePicker({
          start: new Date('2020-01-01'),
          end: new Date('2030-12-31'),
          selected: this.viewModel.selectedDate
        })
          .onChange((value: DatePickerResult) => {
            if (value && value.year !== undefined && value.month !== undefined && value.day !== undefined) {
              this.viewModel.selectedDate = new Date(value.year, value.month, value.day);
            }
          })


        Button('Save Trip').onClick(() => this.viewModel.saveTrip())

        Divider().margin({ top: 15, bottom: 10 }).color(Color.Gray)

        Text('Saved Trips').fontSize(18).fontWeight(FontWeight.Medium).fontColor(Color.White)
        if (this.viewModel.savedTrips.length > 0) {
          List({ space: 8 }) {
            ForEach(this.viewModel.savedTrips, (trip: Trip) => {
              ListItem() {
                Column({ space: 5 }) {
                  Text(`Trip: ${trip.from} -> ${trip.to}`).fontSize(16).fontWeight(FontWeight.Bold).fontColor(Color.White)
                  Text(`${trip.startTime.toLocaleDateString()} - ${trip.transportType}`).fontSize(14).fontColor(Color.Gray)
                }
                .alignItems(HorizontalAlign.Start)
                .padding(8)
                .border({ width: 1, color: Color.Gray, radius: 8 })
              }
            }, (trip: Trip) => trip.id.toString())
          }
          .width('100%')
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
}