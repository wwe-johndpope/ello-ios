//: Playground - noun: a place where people can play

import UIKit

let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzUxMiJ9.eyJpc3MiOiJFbGxvLCBQQkMiLCJpYXQiOjE0ODQ4NDg0NjIsImp0aSI6IjMyZmQ3ZWFmOTJlMGQ1ZWVhMGEwMWU4NWJjNTc4ZDczIiwiZXhwIjoxNDg0OTM0ODYyLCJkYXRhIjp7ImlkIjoyNDksInVzZXJuYW1lIjoic2VhbiIsImFuYWx5dGljc19pZCI6IjM2MjBlN2MzZDkxMzQyMzNiYmU1NzE0YWMxMGU0MWViNmZhZGIzN2YiLCJ3ZWJfb25ib2FyZGluZ192ZXJzaW9uIjoiMiIsImFsbG93c19hbmFseXRpY3MiOnRydWUsImNyZWF0ZWRfYXQiOiIyMDE0LTA4LTA3VDEzOjIwOjIzLjMyNzk1NjAwMCswMDAwIiwiaXNfc3RhZmYiOnRydWV9fQ.eEHtDUPKkCnKhC1qQgGr1b89rJEuAXOGbRLcYUKZ2BExBBz8vr07GYHkiogPvmsUerMwEYRVZq9tKjKk93R2wbaB-8_--Ft7YXtxIsLFNnGGG85RjUfdFsnwEl-tbLS1kB-mh-WtWWE6gAttWqXXlfOffJ48qPHOYmfp4XYcFhfs_DNIwYIhh6nbQOkyRwa3t4ILKk_JFFa9a_sjxze-bx9ST9EWN7IpgTl8BCJTJyamYBSSOTpg-E3azHUuGYh0NqsFZyC8av-NG2iCo5PVkiBIPNWhQSHetslKrQudifBk7N0txH9Ctziw8affCSIyfLVTtFtxy9903pvd-3J5_g"
let jwt = try decode(jwt: token)

jwt.body



func displayIsStaff() {
    guard let data = jwt.body["data"] as? [String: Any],
        let isStaff = data["is_staff"] as? Bool  else { return }
    
    print(isStaff)
}

displayIsStaff()