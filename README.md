# ..:: GOOD TICKETS API ::..

# What is it? :ticket:

It is API for ticket-selling platform.

# Technology stack :gem:

Name |  Version |
| :--: | :---: |
| [Ruby](https://www.ruby-lang.org) | 2.6.1 |
| [Ruby on Rails](http://www.rubyonrails.org/) | 6.0.2.1 |
| [PostgreSQL](https://www.postgresql.org/) | 10.5 |

# Usage :ticket:

## Authentiction :tada:

It is based on devise and JWT authentication. Only authenticated users can have access to resources.
JWT is generated and send to the user during the creation of an account or login process. It has to be used for all next requests. It expires after 2 hours.
It allows recognizing users and is base to allow them or to forbid manage resources.
* Everybody can see all the events. They can be searched by attributes (ransack searching is applied, so all ransack methods can be used).
* Only the organizer can update and destroy the event.
* The organizer can see bought tickets for an organized event, the customer can see tickets bought by himself.

## Required attributes :red_circle:

The user has to have: email and password, to create an account also password confirmation is required.
The event has to have: name, start time, ticket price, and maximum ticket quantity (how many tickets can be bought). If the last one is not given during the creation of the event, it is set for 0 by default.
The ticket has to have just quantity (how many people would like to participate in the event).  But since the app using an adapter for simulate payments, the token has to be given as well. Otherwise, the payment transaction fails.

## Quantities :1234:

Maximum ticket quantity can be set during the creation of the event or updated later (e.g. so many people are interested in your event, you want to sell more tickets or there was a disaster and you want to sell fewer tickets). But, obviously, you can't reduce it below the quantity of already sold tickets.
The app calculates the number of available tickets based on max and sold the number of tickets. Tickets can be bought only if there are available. If you try bought more, you get the number of available tickets.

# Dates :calendar:

There are also rules for dates. You can start to sell tickets as soon as you want (even in the past :smile: ) but not after the event starts. And you can stop to sell them just after starting (but remember... after...) but before the event starts. If the start or end selling of tickets are not given, they just can't be bought.  

# Event and ticket management :fire:

The event organizer can update or destroy the event, but only before it is activated. It means that after sold the first ticket, one can change only name, category, maximum ticket quantity (according to the rules). Next the event can be changed or destroyed after it ends.
Tickets can't be udpated or destroyed.

# Payments

Payments are simulated by the adapter. To simulate successful payment, just add any string as a payment token. To simulate card error, use `card_error` token, and to simulate payment error, use `payment_error` as a token. The token is required.

# Endpoints

`post /signup` with required attributes, to create an account  
`put /signup` with changed attributes, to update the account  
`delete /signup` to destroy the account  
`post /login` with required attributes, to login  
`delete /logout` to logout  
`get /events` to see all events, with query: `get /event?q[]`, e.g. searching for name containing _par_ `get /events?q[name_cont]=par`  
`get /events/1` to see the event with id 1  
`post /events` with at least required attributes as params, to create an event  
`put /events/1` with changed attributes as params, to update the event with id 1  
`delete /event/1` to destroy the event with id 1  
`get /events/1/tickets` to see all tickets of the event with id 1, if the current user is customer, he will see all his tickets  
`get /events/1/tickets/1` to see ticket with id 1  
`post /events/1/tickets` with required attributes, to create a ticket for event with id 1
