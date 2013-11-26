RTBadgeItem
===========

A badge item for navigation bar

#Usage

    RTBadgeItem *item = [[RTBadgeItem alloc] initWithBadgeNumber:3];
    self.navigationItem.leftBarButtonItem = item;
    
    item.badgeColor = [UIColor greenColor];
    item.badgeNumber = 10;
    ...
    item.animating = YES;

#Screenshot
![screenshot1](https://dl.dropboxusercontent.com/u/46239535/RTBadgeItem/s1.png "screenshot1")
![screenshot2](https://dl.dropboxusercontent.com/u/46239535/RTBadgeItem/s2.png "screenshot2")
![screenshot3](https://dl.dropboxusercontent.com/u/46239535/RTBadgeItem/s3.png "screenshot3")

#Licence
`MIT`
