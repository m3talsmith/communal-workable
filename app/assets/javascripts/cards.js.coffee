@pixelFromString = (string) ->
  pixels = string.replace('px')
  pixels = parseFloat pixels

class Card
  constructor: (options={}) ->

    @url       = null
    @content   = null
    @id        = new Date().getTime()
    @pinned    = false
    @dom_class = null
    @dom_id    = null

    options_type = typeof options
    
    if options_type == 'string'
      @content = options
    else if options_type == 'object'
      @url       = options['url']       if options['url']
      @content   = options['content']   if options['content']
      @pinned    = options['pinned']    if options['pinned']
      @dom_class = options['dom_class'] if options['dom_class']
      @dom_id    = options['dom_id']    if options['dom_id']

    @parse_dom_class()

  parse_dom_class: () ->
    return null unless @dom_class

    split_classes     = @dom_class.split(' ')
    remaining_classes = @dom_class - ['card', 'unpinned', 'pinned']
    @dom_class        = remaining_classes
    @dom_class

  fetch_content: () ->
    if @content
      return @content
    else
      $.ajax @url,
        success: (data, status, xhr) ->
          console.log 'success'
          @content = data
        error: (xhr, status, error) ->
          console.log 'status: ' + status
          console.log 'error: ' + error
        beforeSend: (xhr, settings) ->
          console.log 'starting'
        complete: (xhr, status) ->
          console.log 'complete'
    @content

class Deck
  constructor: () ->
    @cards = []

  add_card: (options={}) ->
    card = new Card options
    @cards.push card
    @display_last_card()
    card

  display_card: (card_index) ->
    card    = @cards[card_index]
    id      = new Date().getTime()
    safe_id = id + '-' + card.id  unless card.dom_id
    safe_id = card.dom_id         if     card.dom_id
    pinned  = 'pinned'   if card.pinned == true
    pinned  = 'unpinned' if card.pinned == false

    pinned_cards   = $('.card.pinned')
    unpinned_cards = $('.card.unpinned')


    if pinned_cards.length > 0
      pinned_width = $(pinned_cards[0]).outerWidth(true)

      total_pinned_width = parseFloat(
        pinned_width *
        pinned_cards.length
      )
    else
      total_pinned_width = 0

    if unpinned_cards.length > 0
      unpinned_width = $(unpinned_cards[0]).outerWidth(true)

      total_unpinned_width = parseFloat(
        unpinned_width *
        unpinned_cards.length
      )
    else
      total_unpinned_width = 0

    $('.deck').css {width: (total_pinned_width + total_unpinned_width)}
    $('.deck').append JST['cards/new']({pinned: pinned, id: safe_id, content: card.content})

    @current_card = $('#' + id + '-' + card.id)[0]

    $(@current_card).html card.fetch_content()
    console.log card.content
    card

  display_last_card: () ->
    @display_card @cards.length - 1

  load_content: () ->
    @show_preloader()
    @hide_preloader()
    @show_content()

  show_preloader: () ->
    
  hide_preloader: () ->
  show_content: () ->

  collect: () ->
    @cards = []

    $('.deck .card').each () ->
      deck.add_card
        content:   $(this).html()
        pinned:    $(this).hasClass('pinned')
        dom_class: $(this).attr('class')
        dom_id:    $(this).attr('id')
      $(this).remove()
    # $('a').each ->
    #   unless $(this).hasClass 'dropdown-toggle'
    #     $(this).attr 'rel', 'external'
    $('a').click (event)->
      unless $(this).hasClass 'dropdown-toggle'
        event.preventDefault()
        deck.add_card
          url: this.href

@deck = new Deck
