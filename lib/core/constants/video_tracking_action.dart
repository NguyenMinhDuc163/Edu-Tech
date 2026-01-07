enum VideoTrackingAction {
  videoStart('VIDEO_START'),
  videoWatching('VIDEO_WATCHING'),
  videoPause('VIDEO_PAUSE'),
  videoComplete('VIDEO_COMPLETE');

  final String value;
  const VideoTrackingAction(this.value);
}
