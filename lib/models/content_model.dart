class OnbordingContent {
  String image;
  String title;
  String discription;

  OnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<OnbordingContent> contents = [
  OnbordingContent(
      image: 'assets/images/onboard1.png',
      title: 'RIDE REQUEST',
      discription:
          "Request a ride get picked up by a nearby community driver"),
  OnbordingContent(
      image: 'assets/images/onboard2.png',
      title: 'CONFIRM YOUR DRIVER',
      discription:
          "Huge drivers network helps you find comforable, safe and cheap ride"),
  OnbordingContent(
      image: 'assets/images/onboard3.png',
      title: 'TRACK YOUR RIDE',
      discription:
          "Know your driver in advance and be able to view current location in real time on the map"),
  OnbordingContent(
      image: 'assets/images/onboard4.png',
      title: 'HI, NICE TO MEET YOU',
      discription:
          "Choose your location to start find restaurants around you."),        
];