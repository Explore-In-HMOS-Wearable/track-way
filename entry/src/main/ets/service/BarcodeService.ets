import { scanCore, generateBarcode } from '@kit.ScanKit';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const QR_SIZE = 260;

export class BarcodeService {
  async createQr(content: string): Promise<image.PixelMap> {
    const options: generateBarcode.CreateOptions = {
      scanType: scanCore.ScanType.QR_CODE,
      width: QR_SIZE,
      height: QR_SIZE,
      level: generateBarcode.ErrorCorrectionLevel.LEVEL_H,
      backgroundColor: 0xFFFFFF,
      pixelMapColor: 0x000000,
      margin: 1,
    };
    try {
      return await generateBarcode.createBarcode(content, options);
    } catch (e) {
      const be = e as BusinessError;
      hilog.error(0x0001, '[BarcodeService]', `QR create failed: code=${be?.code}, msg=${be?.message}`);
      throw new Error(be?.message ?? 'QR oluşturulamadı.');
    }
  }
}
