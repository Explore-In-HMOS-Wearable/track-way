import { calendarManager } from '@kit.CalendarKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { getCalendarManagerInstance } from '../entryability/EntryAbility';
import { Trip } from '../model/Trip';

const TRIP_EVENT_PREFIX = 'Trip:';

@Observed
export class TripViewModel {
  fromLocation: string = '';
  toLocation: string = '';
  selectedDate: Date = new Date();
  transportType: string = 'Train';
  savedTrips: Trip[] = [];
  operationMessage: string = '';
  isError: boolean = false;

  private mapEventToTrip(event: calendarManager.Event): Trip | null {
    if (!event.title || !event.title.startsWith(TRIP_EVENT_PREFIX)) {
      return null;
    }

    const titleParts = event.title.replace(TRIP_EVENT_PREFIX, '').trim().split('->');
    if (titleParts.length < 2) {
      return null;
    }

    if (!event.startTime) {
      return null;
    }

    const from = titleParts[0].trim();
    const to = titleParts[1].trim();
    const transport = event.description?.replace('Transport: ', '') || 'Unknown';

    const startTime = event.startTime;

    return new Trip(event.id!, from, to, startTime, transport);
  }

  private setMessage(msg: string, isErr: boolean) {
    this.operationMessage = msg;
    this.isError = isErr;

    setTimeout(() => {
      this.operationMessage = '';
    }, 3000);
  }

  private clearMessage() {
    this.operationMessage = '';
    this.isError = false;
  }

  async loadTrips(): Promise<void> {
    this.clearMessage();

    const mgr = getCalendarManagerInstance();
    if (!mgr) {
      console.warn('Calendar manager not ready yet.');
      return;
    }
    try {
      const calendar = await mgr.getCalendar();
      const allEvents: calendarManager.Event[] = await calendar.getEvents();

      const tripEvents: Trip[] = allEvents
        .map((event: calendarManager.Event): Trip | null => {
          return this.mapEventToTrip(event);
        })
        .filter((trip: Trip | null): boolean => {
          return trip !== null;
        }) as Trip[];

      this.savedTrips = tripEvents.sort((a: Trip, b: Trip) => b.startTime - a.startTime);
      console.info('Successfully loaded trips.');
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to load trips: ${error.message}`);
      this.setMessage('Could not load trips.', true);
    }
  }

  async saveTrip(): Promise<void> {
    this.clearMessage();

    const mgr = getCalendarManagerInstance();
    if (!mgr) {
      this.setMessage('Calendar service is not ready.', true);
      return;
    }
    if (!this.fromLocation || !this.toLocation) {
      this.setMessage('Please fill in all fields.', true);
      return;
    }

    try {
      const calendar = await mgr.getCalendar();
      const event: calendarManager.Event = {
        type: calendarManager.EventType.NORMAL,
        title: `${TRIP_EVENT_PREFIX} ${this.fromLocation} -> ${this.toLocation}`,
        description: `Transport: ${this.transportType}`,
        startTime: this.selectedDate.getTime(),
        endTime: this.selectedDate.getTime() + (60 * 60 * 1000)
      };

      await calendar.addEvent(event);
      this.setMessage('Trip saved successfully!', false);
      this.fromLocation = '';
      this.toLocation = '';
      await this.loadTrips();

    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to save trip: ${error.message}`);
      this.setMessage('Failed to save trip.', true);
    }
  }
}