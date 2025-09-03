<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Mapa Interativo - Regiões de MG</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link rel="stylesheet" href="${BASE_FOLDER}/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

  <style>
    body, html { height: 100%; margin: 0; }
    #map { height: 100%; }
    #sidebar {
      height: 100%;
      overflow-y: auto;
      border-right: 1px solid #ddd;
      padding: 10px;
      background: #fff;
    }
    .container-fluid {
      height: 100%;
    }
    .color-box {
      display: inline-block;
      width: 16px;
      height: 16px;
      margin-right: 5px;
      border: 1px solid #333;
    }
  </style>

  <snk:load/>
</head>
<body>
  <snk:query var="lista">
      SELECT
    CASE 
      WHEN C.NOMECID IN ('Belo Horizonte','Sete Lagoas','Santa Bárbara','Ouro Preto','Curvelo','Itabira','Contagem','Ibirité','Betim','Nova Lima','Santa Luzia','Sabará','Ponte Nova','Ribeirão das Neves','Congonhas','Ouro Branco')
        THEN 'Região de BH'
      WHEN C.NOMECID IN ('Montes Claros','Janaúba','Salinas','Januária','Pirapora','São Francisco','Espinosa')
        THEN 'Região de Montes Claros'
      WHEN C.NOMECID IN ('Teófilo Otoni','Capelinha','Almenara','Diamantina','Araçuaí','Pedra Azul','Águas Formosas','Chapada do Norte','Jequitinhonha','Itaobim')
        THEN 'Região de Teófilo Otoni'
      WHEN C.NOMECID IN ('Governador Valadares','Guanhães','Mantena','Aimorés-Resplendor','Conselheiro Pena','Peçanha')
        THEN 'Região de GV'
      WHEN C.NOMECID IN ('Ipatinga','Caratinga','João Monlevade','Coronel Fabriciano','Timóteo','Santana do Paraíso','Ipaba','Bom Jesus do Galho','Belo Oriente','Tarumirim','Inhapim','Nova Era')
        THEN 'Região de Ipatinga'
      WHEN C.NOMECID IN ('Juiz de Fora','Manhuaçu','Ubá','Ponte Nova','Muriaé','Cataguases','Viçosa','Carangola','São João Nepomuceno','Bicas','Além Paraíba','Barbacena','Conselheiro Lafaiete','São João del Rei')
        THEN 'Região de Juiz de Fora'
      WHEN C.NOMECID IN ('Varginha','Passos','Alfenas','Lavras','Guaxupé','Três Corações','Três Pontas','Boa Esperança','São Sebastião do Paraíso','Campo Belo','Piumhi','Nepomuceno')
        THEN 'Região de Varginha'
      WHEN C.NOMECID IN ('Pouso Alegre','Poços de Caldas','Itajubá','São Lourenço','Caxambu','Baependi','Ouro Fino')
        THEN 'Região de Pouso Alegre'
      WHEN C.NOMECID IN ('Uberaba','Araxá','Frutal','Iturama','Sacramento')
        THEN 'Região de Uberaba'
      WHEN C.NOMECID IN ('Uberlândia','Ituiutaba','Monte Carmelo','Araguari')
        THEN 'Região de Uberlândia'
      WHEN C.NOMECID IN ('Patos de Minas','Unaí','Patrocínio')
        THEN 'Região de Patos de Minas'
      WHEN C.NOMECID IN ('Divinópolis','Formiga','Dores do Indaiá','Pará de Minas','Oliveira','Abaeté','Conselheiro Lafaiete')
        THEN 'Região de Divinópolis'
    END AS REGIAO,
    SUM(CAB.VLRNOTA) AS TOTAL_VENDAS
FROM TGFCAB CAB
JOIN TGFPAR PAR ON PAR.CODPARC = CAB.CODPARC
JOIN TSICID C ON C.CODCID = PAR.CODCID
WHERE CAB.TIPMOV = 'V'
  AND CAB.DTNEG BETWEEN 
        TRUNC(ADD_MONTHS(SYSDATE, -3), 'MM')  -- 1º dia do mês de 3 meses atrás
    AND LAST_DAY(ADD_MONTHS(SYSDATE, -1))     -- último dia do mês passado
GROUP BY 
    CASE 
      WHEN C.NOMECID IN ('Belo Horizonte','Sete Lagoas','Santa Bárbara','Ouro Preto','Curvelo','Itabira','Contagem','Ibirité','Betim','Nova Lima','Santa Luzia','Sabará','Ponte Nova','Ribeirão das Neves','Congonhas','Ouro Branco')
        THEN 'Região de BH'
      WHEN C.NOMECID IN ('Montes Claros','Janaúba','Salinas','Januária','Pirapora','São Francisco','Espinosa')
        THEN 'Região de Montes Claros'
      WHEN C.NOMECID IN ('Teófilo Otoni','Capelinha','Almenara','Diamantina','Araçuaí','Pedra Azul','Águas Formosas','Chapada do Norte','Jequitinhonha','Itaobim')
        THEN 'Região de Teófilo Otoni'
      WHEN C.NOMECID IN ('Governador Valadares','Guanhães','Mantena','Aimorés-Resplendor','Conselheiro Pena','Peçanha')
        THEN 'Região de GV'
      WHEN C.NOMECID IN ('Ipatinga','Caratinga','João Monlevade','Coronel Fabriciano','Timóteo','Santana do Paraíso','Ipaba','Bom Jesus do Galho','Belo Oriente','Tarumirim','Inhapim','Nova Era')
        THEN 'Região de Ipatinga'
      WHEN C.NOMECID IN ('Juiz de Fora','Manhuaçu','Ubá','Ponte Nova','Muriaé','Cataguases','Viçosa','Carangola','São João Nepomuceno','Bicas','Além Paraíba','Barbacena','Conselheiro Lafaiete','São João del Rei')
        THEN 'Região de Juiz de Fora'
      WHEN C.NOMECID IN ('Varginha','Passos','Alfenas','Lavras','Guaxupé','Três Corações','Três Pontas','Boa Esperança','São Sebastião do Paraíso','Campo Belo','Piumhi','Nepomuceno')
        THEN 'Região de Varginha'
      WHEN C.NOMECID IN ('Pouso Alegre','Poços de Caldas','Itajubá','São Lourenço','Caxambu','Baependi','Ouro Fino')
        THEN 'Região de Pouso Alegre'
      WHEN C.NOMECID IN ('Uberaba','Araxá','Frutal','Iturama','Sacramento')
        THEN 'Região de Uberaba'
      WHEN C.NOMECID IN ('Uberlândia','Ituiutaba','Monte Carmelo','Araguari')
        THEN 'Região de Uberlândia'
      WHEN C.NOMECID IN ('Patos de Minas','Unaí','Patrocínio')
        THEN 'Região de Patos de Minas'
      WHEN C.NOMECID IN ('Divinópolis','Formiga','Dores do Indaiá','Pará de Minas','Oliveira','Abaeté','Conselheiro Lafaiete')
        THEN 'Região de Divinópolis'
    END
ORDER BY TOTAL_VENDAS DESC
  </snk:query>

    <div class="container-fluid">
      <div class="row h-100">
        
        <!-- Sidebar -->
        <div id="sidebar" class="col-3">
          <h5 class="text-center mb-3">Vendas por Região</h5>
          <table class="table table-sm table-striped">
            <thead class="table-light">
              <tr>
                <th>Região</th>
                <th>Total Vendas</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach items="${lista.rows}" var="row">
                <tr>
                  <td>${row.REGIAO}</td>
                  <td>R$ <fmt:formatNumber value="${row.TOTAL_VENDAS}" type="number" minFractionDigits="2" maxFractionDigits="2"/></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>

        <!-- Mapa -->
        <div id="map" class="col-9"></div>

      </div>
    </div>

    <script src="${BASE_FOLDER}/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
      const map = L.map('map', { center: [-18.5, -44], zoom: 6, minZoom: 6, maxZoom: 12 });
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 19 }).addTo(map);

      fetch("${BASE_FOLDER}/Mapa/map_geo.jsp")
        .then(res => res.json())
        .then(data => {
          const geojson = L.geoJSON(data, {
            style: feature => ({
              color: feature.properties.stroke || '#333',
              weight: +(feature.properties['stroke-width'] ?? 2),
              opacity: +(feature.properties['stroke-opacity'] ?? 1),
              fillColor: feature.properties.fill || '#ACAF50',
              fillOpacity: +(feature.properties['fill-opacity'] ?? 0.65)
            }),
            onEachFeature: (feature, layer) => {
              const name = feature.properties?.name || 'Cidade';
              layer.bindTooltip(name, { permanent: true, direction: 'center', className: 'region-label' });
            }
          }).addTo(map);
          map.fitBounds(geojson.getBounds(), { padding: [20,20] });
        });
    </script>

</body>
</html>
