import { calendarManager } from '@kit.CalendarKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import { calendarMgr } from '../entryability/EntryAbility';
import { Trip } from '../model/Trip';

const TRIP_EVENT_PREFIX = 'Trip:';

@ObservedV2
export class TripViewModel {
  @Trace fromLocation: string = '';
  @Trace toLocation: string = '';
  @Trace selectedDate: Date = new Date();
  @Trace transportType: string = 'Train';
  @Trace savedTrips: Trip[] = [];

  private mapEventToTrip(event: calendarManager.Event): Trip | null {
    if (!event.title || !event.title.startsWith(TRIP_EVENT_PREFIX)) {
      return null;
    }

    const titleParts = event.title.replace(TRIP_EVENT_PREFIX, '').trim().split('->');
    if (titleParts.length < 2) {
      return null;
    }

    const from = titleParts[0].trim();
    const to = titleParts[1].trim();
    const transport = event.description?.replace('Transport: ', '') || 'Unknown';
    const startTime = new Date(event.startTime!);

    return new Trip(event.id!, from, to, startTime, transport);
  }

  async loadTrips(): Promise<void> {
    if (!calendarMgr) {
      promptAction.showToast({ message: 'Calendar service is not ready.' });
      return;
    }
    try {
      const calendar = await calendarMgr.getCalendar();
      const allEvents = await calendar.getEvents();
      const tripEvents = allEvents
        .map(event => this.mapEventToTrip(event))
        .filter(trip => trip !== null) as Trip[];
      this.savedTrips = tripEvents.sort((a, b) => b.startTime.getTime() - a.startTime.getTime());
      console.info('Successfully loaded trips.');
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to load trips: ${error.message}`);
      promptAction.showToast({ message: 'Could not load trips.' });
    }
  }

  async saveTrip(): Promise<void> {
    if (!calendarMgr) {
      promptAction.showToast({ message: 'Calendar service is not ready.' });
      return;
    }
    if (!this.fromLocation || !this.toLocation) {
      promptAction.showToast({ message: 'Please fill in all fields.' });
      return;
    }

    try {
      const calendar = await calendarMgr.getCalendar();
      const event: calendarManager.Event = {
        type: calendarManager.EventType.NORMAL,
        title: `${TRIP_EVENT_PREFIX} ${this.fromLocation} -> ${this.toLocation}`,
        description: `Transport: ${this.transportType}`,
        startTime: this.selectedDate.getTime(),
        endTime: this.selectedDate.getTime() + (60 * 60 * 1000), // 1 hour duration
        isAllDay: true,
      };
      await calendar.addEvent(event);
      promptAction.showToast({ message: 'Trip saved successfully!' });

      this.fromLocation = '';
      this.toLocation = '';
      await this.loadTrips();
    } catch (err) {
      const error = err as BusinessError;
      console.error(`Failed to save trip: ${error.message}`);
      promptAction.showToast({ message: 'Failed to save trip.' });
    }
  }
}