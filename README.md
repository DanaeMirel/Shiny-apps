# Shiny Apps

## Exemples of my work building web applications and interactive  dashboards with Shiny 

Building a Shiny app is a modular process. You start with the UI, then you work on the server code, 
building outputs based on the user inputs.

1. **Alien App** - The National UFO Reporting Center (NUFORC) has collected sightings data throughout the last century. 
This app allows users to select a U.S. state and a time period in which the sightings occurred.

2. **BMI App** - Sometimes you want to perform an action in response to an event. For example, you might want to display a 
notification or modal dialog, in response to a click.

The `observeEvent()` function allows you to achieve this. It accepts two arguments:
   - The event you want to respond to.
   - The function that should be called whenever the event occurs.

3. **Popular baby names App** - This app lets a user choose sex and year, and will display the top 10 most popular names
in that year. The showed plot has been buil with the plotly package and the table uses the kableExtra package.  