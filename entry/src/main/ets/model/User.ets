export class User{
  uid: string;
  email: string;
  displayName?: string;
  profilePictureUrl?: string;

  constructor( uid: string,
  email: string,
  displayName?: string,
  profilePictureUrl?: string) {
    this.uid=uid;
    this.email=email;
    this.displayName=displayName;
    this.profilePictureUrl=profilePictureUrl;
  }
}