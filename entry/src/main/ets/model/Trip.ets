// /entry/src/main/ets/model/Trip.ets

export class Trip {
  id: number;
  from: string;
  to: string;
  startTime: Date;
  transportType: string;

  constructor(id: number, from: string, to: string, startTime: Date, transportType: string) {
    this.id = id;
    this.from = from;
    this.to = to;
    this.startTime = startTime;
    this.transportType = transportType;
  }
}