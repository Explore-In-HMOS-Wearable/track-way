export class Trip {
  id: number;
  from: string;
  to: string;
  startTime: number;
  transportType: string;

  constructor(id: number, from: string, to: string, startTime: number, transportType: string) {
    this.id = id;
    this.from = from;
    this.to = to;
    this.startTime = startTime;
    this.transportType = transportType;
  }
}