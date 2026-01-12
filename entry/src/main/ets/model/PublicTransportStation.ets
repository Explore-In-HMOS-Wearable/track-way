import { Location } from './Location';

export enum StationType{
  Metro='Metro',
  BUS='Bus',
  TRAM='Tramway',
  FERRY='Ferry'
}

export class PublicTransportStation{
  id: string;
  name: string;
  type: StationType;
  location: Location;
  distanceKm?: number;
  lines?: string[];

  constructor( id: string,
  name: string,
  type: StationType,
  location: Location,
  distanceKm?: number,
  lines?: string[]
  ) {
    this.id=id;
    this.name=name;
    this.type=type;
    this.location=location;
    this.distanceKm=distanceKm;
    this.lines=lines;
  }
}

