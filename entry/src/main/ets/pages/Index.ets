import {PnrPage} from './PnrPage';

@Entry
@Component
struct Index {
  build() {
    RelativeContainer() {
      PnrPage();
    }
  }
}