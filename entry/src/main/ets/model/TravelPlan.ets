import { Location } from "./Location";

export class TravelPlan{
  id:string;
  userId: string;
  title: string;
  description?: string;
  startTime: Date;
  endTime?: Date;
  origin?: Location;
  destination?: Location;
  notes?: string;

  constructor(  id:string,
  userId: string,
  title: string,
  startTime: Date,
    description?: string,
    endTime?: Date,
  origin?: Location,
  destination?: Location,
  notes?: string
  ) {
    this.id=id;
    this.userId=userId;
    this.title=title;
    this.startTime=startTime;
    this.description=description;
    this.endTime=endTime;
    this.origin=origin;
    this.destination=destination;
    this.notes=notes;
  }

}