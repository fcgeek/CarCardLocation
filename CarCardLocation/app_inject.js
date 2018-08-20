var baseUrl = "http://market.cmbchina.com/ccard/2012car/";

function getGasStations(html) {
    var el = document.createElement( 'html' );
    el.innerHTML = html;
    var showallcitys = el.getElementsByClassName('listdetail');
    var tableHtml = showallcitys[0].getElementsByTagName('table')[0];
    var gasStations = [];
    tableHtml.querySelectorAll('tr').forEach(function(tr){
                                             var gs = new Object();
                                             var tds = tr.querySelectorAll('th, td');
                                             gs.company = tds[0].innerHTML;
                                             gs.region = tds[1].innerHTML;
                                             gs.name = tds[2].innerHTML;
                                             gs.address = tds[3].innerHTML;
                                             gasStations.push(gs);
                                             });
    return JSON.stringify(gasStations);
}

function getAreas(html) {
    var el = document.createElement( 'html' );
    el.innerHTML = html;
    var showallcitys = el.getElementsByClassName('showallcity');
    var areaItems = showallcitys[0].getElementsByTagName('p');
    var areas = new Array();
    for (var index = 0; index < areaItems.length; index++) {
        areas[index] = new Object();
        areas[index].name = areaItems[index].getElementsByClassName('red2')[0].innerHTML;
        var citys = new Array();
        var area = areaItems[index].getElementsByTagName('a');
        for (var cityIndex = 0; cityIndex < area.length; cityIndex++) {
            citys[cityIndex] = new Object();
            citys[cityIndex].name = area[cityIndex].textContent;
            citys[cityIndex].link = baseUrl + area[cityIndex].attributes.getNamedItem('href').value;
        }
        areas[index].citys = citys;
    }
    return JSON.stringify(areas);
}
