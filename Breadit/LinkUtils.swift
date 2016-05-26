//
//  LinkUtils.swift
//  Breadit
//
//  Created by William Hester on 5/25/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit
import SafariServices

struct LinkUtils {
    static func viewControllerFor(link: Link) -> UIViewController? {
        switch link.linkType {
        case .Normal:
            let preview = SFSafariViewController(URL: NSURL(string: link.url)!)
            preview.modalTransitionStyle = .CoverVertical
            return preview
        case .YouTube:
            let preview = YouTubePreviewViewController()
            let navigation = UINavigationController(rootViewController: preview)
            navigation.navigationBar.barStyle = .Black
            navigation.modalTransitionStyle = .CoverVertical
            preview.link = link
            return navigation
        case .Image(_):
            let preview = PreviewViewController()
            preview.modalPresentationStyle = .OverFullScreen
            preview.imageUrl = link.previewUrl
            return preview
        case .Reddit(let redditType):
            switch redditType {
            case .Submission:
                let preview = CommentViewController()
                preview.permalink = link.id!
                return preview
            case .Subreddit:
                let preview = SubmissionViewController()
                preview.submissionStore = SubmissionStore(subredditDisplay: link.id!)
                return preview
            case .User:
                break
            case .RedditLive:
                break
            case .Messages:
                break
            case .Compose:
                break
            }
        }
        return nil
    }
}
