import { map, mapCommon, MapComponent } from '@kit.MapKit';

@Entry
@Component
struct Index {
  private mapController?: map.MapComponentController;
  @State mapOptions?: mapCommon.MapOptions | null = null;
  @State markerOptions?: mapCommon.MarkerOptions | null = null;
  aboutToAppear() {
    const defaultLocation: mapCommon.LatLng = {
      latitude: 38.447967,
      longitude: 27.179380
    };
    this.mapOptions = {
      position: {
        target: defaultLocation,
        zoom: 17
      }
    };

    this.markerOptions = {
      position: defaultLocation,
      title: 'Huawei Izmir',
      clickable: true,
      alpha: 1,
      anchorU: 0.5,
      anchorV: 0.5
    };
  }

  build() {
    Column() {
      if (this.mapOptions) {
        MapComponent({
          mapOptions: this.mapOptions,
          mapCallback: async (err, ctrl) => {
            if (!err) {
              this.mapController = ctrl;
              if (this.markerOptions) {
                await ctrl?.addMarker(this.markerOptions);
              }
            }
          }
        })
          .width('105%')
          .height(300)
      } else {
        Text('Loading map...')
          .width('100%')
          .textAlign(TextAlign.Center)
      }
    }
    .padding(12)
  }
}
