import { image } from '@kit.ImageKit';
import { scanCore, generateBarcode } from '@kit.ScanKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = '[PnrViewModel]';

@Observed
export class PNRViewModel {
  pnrNumber: string = '';
  qrCodeImage: image.PixelMap | undefined = undefined;
  isLoading: boolean = false;
  errorMessage: string = '';

  async generateQrCode() {
    if (!this.pnrNumber) {
      this.errorMessage = 'Enter a PNR number.';
      hilog.error(0x0001, TAG, this.errorMessage);
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';
    this.qrCodeImage = undefined;

    const options: generateBarcode.CreateOptions = {
      scanType: scanCore.ScanType.QR_CODE,
      width: 400,
      height: 400
    };

    try {
      const pixelMapResult = await generateBarcode.createBarcode(this.pnrNumber, options);
      this.qrCodeImage = pixelMapResult;
      hilog.info(0x0001, TAG, 'QR Code genereted.');
    } catch (error) {
      const businessError = error as BusinessError;
      this.errorMessage = `ERROR: ${businessError.message} (Code: ${businessError.code})`;
      hilog.error(0x0001, TAG, this.errorMessage);
    } finally {
      this.isLoading = false;
    }
  }
}