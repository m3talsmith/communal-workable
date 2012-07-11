@pixelFromString = (string) ->
  pixels = string.replace('px')
  pixels = parseFloat pixels

class Card
  constructor: (options={}) ->

    @url     = null
    @content = null
    @id      = new Date().getTime()
    @pinned  = false

    options_type = typeof options
    
    if options_type == 'string'
      @content = options
    else if options_type == 'object'
      @url = options['url'] if options['url']

class Deck
  constructor: () ->
    @cards = []

  add_card: (options={}) ->
    card = new Card options
    @cards.push card
    @display_last_card()
    card

  display_card: (card_index) ->
    id     = new Date().getTime()
    card   = @cards[card_index]
    pinned = 'pinned'   if card.pinned == true
    pinned = 'unpinned' if card.pinned == false

    $('.deck').append '<div class="card ' + pinned + '" id="' + id + '-' + card.id + '">' + card.content + '</div>'

    @current_card = $('#' + id + '-' + card.id)[0]

    pinned_cards   = $('.card.pinned')
    unpinned_cards = $('.card.unpinned')

    if pinned_cards.length > 0
      pinned_width   = $(pinned_cards[0]).width()
      pinned_height  = $(pinned_cards[0]).height()
      pinned_margin  = $(pinned_cards[0]).css('margin').replace(/px/g, '').split(' ')
      pinned_margin  =
        left:   pixelFromString pinned_margin[0]
        right:  pixelFromString pinned_margin[1]
        top:    pixelFromString pinned_margin[2]
        bottom: pixelFromString pinned_margin[3]
      
      total_pinned_width = parseFloat(parseFloat(pinned_margin['left'] + pinned_margin['right']) * (pinned_cards.length - 1)) + parseFloat(pinned_width * (pinned_cards.length - 1))
    else
      total_pinned_width = 0

    if unpinned_cards.length > 0
      unpinned_width   = $(unpinned_cards[0]).width()
      unpinned_height  = $(unpinned_cards[0]).height()
      unpinned_margin  = $(unpinned_cards[0]).css('margin').replace(/px/g, '').split(' ')
      unpinned_margin  =
        left:   pixelFromString unpinned_margin[0]
        right:  pixelFromString unpinned_margin[1]
        top:    pixelFromString unpinned_margin[2]
        bottom: pixelFromString unpinned_margin[3]

      total_unpinned_width = parseFloat(parseFloat(unpinned_margin['left'] + unpinned_margin['right']) * (unpinned_cards.length - 1)) + parseFloat(unpinned_width * (unpinned_cards.length - 1))
    else
      total_unpinned_width = 0

    $('.deck').css {width: (total_pinned_width + total_unpinned_width)}

    card

  display_last_card: () ->
    @display_card @cards.length - 1

  collect: () ->
    @cards = []

    $('.deck .card').each () ->
      deck.add_card $(this).html()
      $(this).remove()

@deck = new Deck
