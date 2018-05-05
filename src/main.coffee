import Backbone from 'backbone'
import Marionette from 'backbone.marionette'
import TkApplet from 'tbirds/tkapplet'
import capitalize from 'tbirds/util/capitalize'

import Controller from './controller'
import './dbchannel'

appName = 'moviedb'

MainChannel = Backbone.Radio.channel 'global'
AppChannel = Backbone.Radio.channel appName


appletMenu = [
  {
    label: 'TV Search'
    url: '#moviedb/search/tv'
    icon: '.fa.fa-search'
  }
  {
    label: 'Movie Search'
    url: '#moviedb/search/movies'
    icon: '.fa.fa-search'
  }
  ]

class Router extends Marionette.AppRouter
  appRoutes:
    'moviedb': 'viewIndex'
    'moviedb/search/tv': 'viewIndex'
    'moviedb/search/movies': 'searchMovies'
    'moviedb/tv/shows/view/:id': 'viewTvShow'
    'moviedb/movies/view/:id': 'viewMovie'
    
class Applet extends TkApplet
  Controller: Controller
  Router: Router
  appletEntries: [
    {
      label: "#{capitalize appName} Menu"
      menu: appletMenu
    }
  ]

export default Applet
