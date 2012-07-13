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
      @url     = options['url']     if options['url']
      @content = options['content'] if options['content']
      @pinned  = options['pinned']  if options['pinned']


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
    safe_id = id + '-' + card.id
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
    card

  display_last_card: () ->
    @display_card @cards.length - 1

  collect: () ->
    @cards = []

    $('.deck .card').each () ->
      deck.add_card
        content: $(this).html()
        pinned: $(this).hasClass('pinned') 
      $(this).remove()

@deck = new Deck
