const BREWERIES = {}

BREWERIES.show = () => {
    $("#brewerytable tr:gt(0)").remove()
    const table = $("#brewerytable")

  BREWERIES.list.forEach((brewery) => {
    if(brewery['active']){
        act='Active'
   }
       else {
       act = 'Retired'
   }

   table.append('<tr>'
   + '<td>' + brewery['name'] + '</td>'
   + '<td>' + brewery['year']+ '</td>'
   + '<td>' + brewery['beers']['count']+ '</td>'
   + '<td>' + act + '</td>'
   + '</tr>')
})

  //$("#breweries").html('<ul>' + brewery_list.join('') + '</ul>')
}


BREWERIES.sort_by_name = () => {
    BREWERIES.list.sort((a, b) => {
      return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    })
  }
  
  BREWERIES.sort_by_year = () => {
    BREWERIES.list.sort((a, b) => {
      return a.year < b.year;
    })
  }
  
  BREWERIES.sort_by_number_of_beers = () => {
    BREWERIES.list.sort((a, b) => {
      return a.beers.count < b.beers.count;
    })
  }


BREWERIES.reverse = () => {
    BREWERIES.list.reverse()
  }

document.addEventListener("turbolinks:load", () => {

    if ($("#brewerytable").length == 0) {
        return
      } 

    $("#name").click((e) => {
        e.preventDefault()
        BREWERIES.sort_by_name()
        BREWERIES.show();
        
      })
    
      $("#year").click((e) => {
        e.preventDefault()
        BREWERIES.sort_by_year()
        BREWERIES.show()
      })
    
      $("#number_of_beers").click((e) => {
        e.preventDefault()
        BREWERIES.sort_by_number_of_beers()
        BREWERIES.show()
      })

    $("#reverse").click((e) => {
        e.preventDefault()
        BREWERIES.reverse()
        BREWERIES.show()
      })

  $.getJSON('breweries.json', (breweries) => {
    BREWERIES.list = breweries
    BREWERIES.show()
  })
})


