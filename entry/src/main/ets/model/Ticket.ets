export class Ticket{
  id: string;
  userId:string;
  qrCodeData:string;
  type: string;
  validForm: Date;
  validUntil:Date;
  issuer?: string;
  details?: string;

  constructor(  id: string,
  userId:string,
  qrCodeData:string,
  type: string,
  validForm: Date,
  validUntil:Date,
  issuer?: string,
  details?: string
  ) {
    this.id=id;
    this.userId=userId;
    this.qrCodeData=qrCodeData;
    this.type=type;
    this.validForm=validForm;
    this.validUntil=validUntil;
    this.issuer=issuer;
    this.details=details;
  }

}