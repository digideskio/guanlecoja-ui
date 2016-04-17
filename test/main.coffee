unless __karma__?
    window.describe = ->

# define sample application logic

m = angular.module("app", ["guanlecoja.ui", "ngSanitize"]);
README = "https://github.com/tardyp/guanlecoja-ui/blob/master/Readme.md"
m.config ($stateProvider, glMenuServiceProvider, $urlRouterProvider) ->
        $urlRouterProvider.otherwise('/bugcab')
        groups = []
        for i in ["cab", "camera", "bug", "calendar", "ban", "archive", "edit"]
            group =
                name: i
                items: []
            for j in ["cab", "camera", "bug", "calendar", "ban", "archive", "edit"]
                group.items.push
                    name: i + j
                if i == "bug"
                    break
            groups.push group
            glMenuServiceProvider.addGroup
                name: group.name
                caption: _.capitalize(group.name)
                icon: group.name
                order: group.name.length

        glMenuServiceProvider.setFooter [
            caption: "Github"
            href: "https://github.com/tardyp/guanlecoja-ui"
        ,
            caption: "Help"
            href: README
        ,
            caption: "About"
            href: README
        ]
        glMenuServiceProvider.setAppTitle("Guanlecoja-UI")
        for group in groups
            for item in group.items
                state =
                    controller: "dummyController"
                    template: "<div class='container'><div btf-markdown ng-include=\"'Readme.md'\">
</div></div>"
                    name: item.name
                    url: '/' + item.name
                    data:
                        group: group.name
                        caption: _.capitalize(item.name)
                $stateProvider.state(state)

m.controller "dummyController", ($scope, $state, glBreadcrumbService, glNotificationService,
                                 glTopbarContextualActionsService) ->

    # You can set different actions given the route
    glTopbarContextualActionsService.setContextualActions([
        caption: "Download Doc"
        icon: "download"
        action: -> document.location = 'Readme.md'
    ,
        caption: "View on Github"
        icon: "github"
        help: "Go to the github page of guanleoja-ui"
        action: -> document.location = README
    ,
        icon: "google-plus"
        action: -> document.location = "https://plus.google.com"
        ])
    $scope.stateName = $state.current.name
    glNotificationService.notify(msg:"You just transitioned to #{$scope.stateName}!",
                                title:"State transitions", group:"state")

    glBreadcrumbService.setBreadcrumb [
        caption: _.capitalize($state.current.data.group)
    ,
        caption: _.capitalize($state.current.name)
        sref: $state.current.name
    ]
#
# angular-markdown-directive v0.3.0
# (c) 2013-2014 Brian Ford http://briantford.com
# License: MIT

m.provider("markdownConverter", ->
  opts = {}
  config: (newOpts) ->
    opts = newOpts
    return

  $get: ->
    new Showdown.converter(opts)
).directive "btfMarkdown", ($sanitize, markdownConverter) ->
  restrict: "AE"
  link: (scope, element, attrs) ->
    if attrs.btfMarkdown
      scope.$watch attrs.btfMarkdown, (newVal) ->
        html = (if newVal then $sanitize(markdownConverter.makeHtml(newVal)) else "")
        element.html html
        return

    else
      html = $sanitize(markdownConverter.makeHtml(element.text()))
      element.html html
    return
