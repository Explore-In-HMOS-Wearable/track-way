export class Location{
  latitude: number;
  longitude: number;
  name?: string;
  address?: string;

  constructor( latitude: number,
  longitude: number,
  name?: string,
  address?: string
  ) {
    this.latitude=latitude;
    this.longitude=longitude;
    this.name=name;
    this.address=address;
  }
}