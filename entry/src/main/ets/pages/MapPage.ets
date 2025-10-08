
import router from '@ohos.router';
import { MapComponent, map, mapCommon } from '@kit.MapKit';
import { geoLocationManager } from '@kit.LocationKit';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { BusinessError, AsyncCallback } from '@kit.BasicServicesKit';

@Entry
@Component
struct MapPage {
  @State private mapController: map.MapComponentController | null = null;
  @State private isLoading: boolean = true;

  private mapOptions: mapCommon.MapOptions = {
    position: {
      target: { latitude: 41.015137, longitude: 28.979530 },
      zoom: 12
    }
  };

  private mapCallback: AsyncCallback<map.MapComponentController> = (err, controller) => {
    if (!err) {
      this.mapController = controller;
      this.fetchLocationAndAddStops();
    } else {
      console.error(`Failed to load map: Code: ${err.code}, Message: ${err.message}`);
    }
  };

  async fetchLocationAndAddStops() {
    const context = getContext(this) as common.UIAbilityContext;
    try {
      await abilityAccessCtrl.createAtManager().requestPermissionsFromUser(context, ['ohos.permission.LOCATION']);

      console.info('Getting location...');
      const location = await geoLocationManager.getCurrentLocation();
      const userLatLng: mapCommon.LatLng = { latitude: location.latitude, longitude: location.longitude };

      if (!this.mapController) return;

      this.mapController.clear();
      this.mapController.addMarker({ position: userLatLng, title: 'My Location' });

      const cameraUpdate = map.newCameraPosition({
        target: userLatLng,
        zoom: 15
      });
      this.mapController.animateCamera(cameraUpdate, 1000);

      this.addMockStops(userLatLng);

    } catch (error) {
      const err = error as BusinessError;
      console.error(`An error occurred: ${err.code}, ${err.message}`);
    } finally {
      this.isLoading = false;
    }
  }

  addMockStops(baseLocation: mapCommon.LatLng) {
    if (!this.mapController) return;

    const metroStopLocation: mapCommon.LatLng = {
      latitude: baseLocation.latitude + 0.008,
      longitude: baseLocation.longitude + 0.005
    };
    this.mapController.addMarker({
      position: metroStopLocation,
      title: 'Metro Stop (Mock)',
    });

    const busStopLocation: mapCommon.LatLng = {
      latitude: baseLocation.latitude - 0.005,
      longitude: baseLocation.longitude - 0.003
    };
    this.mapController.addMarker({
      position: busStopLocation,
      title: 'Bus Stop (Mock)',
    });

    console.info('Mock stops have been added.');
  }

  build() {
    Stack() {
      MapComponent({
        mapOptions: this.mapOptions,
        mapCallback: this.mapCallback
      })
        .width('100%')
        .height('100%');

      Row() {
        Image($r('app.media.iconBack'))
          .width(32)
          .height(32)
          .fillColor(Color.Black)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .padding(4)
          .shadow({ radius: 5, color: Color.Gray, offsetX: 2, offsetY: 2 })
          .onClick(() => {
            router.back();
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .padding({ top: 20, left: 15 })

      if (this.isLoading) {
        Text('Getting location...')
          .fontSize(18)
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(10)
          .shadow({ radius: 5, color: Color.Gray, offsetX: 2, offsetY: 2 });
      }
    }
    .width('100%')
    .height('100%');
  }
}