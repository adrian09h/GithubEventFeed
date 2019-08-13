# GithubEventFeed

The app shows github events fetched from https://api.github.com/events

## Feature
- Shows github event feed
- Refreshes at every 10 seconds
- Loads more events when user reaches at the end of event list.
- Search events by username
- Handled following events

    ```
    enum EventType: String {
        case fork = "ForkEvent"
        case commitComment = "CommitCommentEvent"
        case create = "CreateEvent"
        case issueComment = "IssueCommentEvent"
        case issues = "IssuesEvent"
        case member = "MemberEvent"
        case organizationBlock = "OrgBlockEvent"
        case `public` = "PublicEvent"
        case pullRequest = "PullRequestEvent"
        case pullRequestReviewComment = "PullRequestReviewCommentEvent"
        case push = "PushEvent"
        case release = "ReleaseEvent"
        case star = "WatchEvent"
        case unknown = ""
    }
    ```
## Preview

https://www.dropbox.com/s/057iy1t24b0nezs/Screencast.mov?dl=0


## Main technologies used
- [x] Clean architecture (RxSwift and MVVM)
- [x] REST API v3 (for unauthenticated or basic authentication) (Moya, ObjectMapper)
- [x] Flow coordinators, with MVVM-Rx

## Install and run
1. Clone this repository
2. Run `pod install` in terminal and run GithubEvents.xcworkspace

## Limitation on Github event api usage
- Github event api has a limitation, it cannot be called more than 60 times within an hour.
  The app fetches events at every 10 seconds, that's why, the app will get an api error in about 600 seconds after it's launched.
- Handled only main event types
- Omitted detail view
