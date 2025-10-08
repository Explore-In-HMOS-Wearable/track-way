export class Weather{
  temperatureC: number;
  condition: string;
  iconUrl?: string;
  humidity?: number;
  windSpeedKmH?: number;
  feelsLikeC?: number;

  constructor(  temperatureC: number,
  condition: string,
  iconUrl?: string,
  humidity?: number,
  windSpeedKmH?: number,
  feelsLikeC?: number) {
    this.temperatureC=temperatureC;
    this.condition=condition;
    this.iconUrl=iconUrl;
    this.humidity=humidity;
    this.windSpeedKmH=windSpeedKmH;
    this.feelsLikeC=feelsLikeC;

  }
}