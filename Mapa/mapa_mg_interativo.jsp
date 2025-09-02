<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>

<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <title>Mapa Interativo - Regiões de MG</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
  <snk:load/>

  <style>
    html, body { height: 100%; margin: 0; }
    #map { width: 100%; height: 100%; }
    .region-label {
      background: transparent; border: none; box-shadow: none;
      font-weight: 700; color: #111;
      text-shadow: 1px 1px 3px #fff, -1px -1px 3px #fff;
      pointer-events: none;
    }
  </style>
</head>
<body>
<div id="map"></div>

<!-- ===================== QUERY Sankhya ===================== -->
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
    AND CAB.DTNEG BETWEEN :PERIODO.INI AND :PERIODO.FIN
    AND (
      C.NOMECID IN ('Belo Horizonte','Sete Lagoas','Santa Bárbara','Ouro Preto','Curvelo','Itabira','Contagem','Ibirité','Betim','Nova Lima','Santa Luzia','Sabará','Ponte Nova','Ribeirão das Neves','Congonhas','Ouro Branco')
      OR C.NOMECID IN ('Montes Claros','Janaúba','Salinas','Januária','Pirapora','São Francisco','Espinosa')
      OR C.NOMECID IN ('Teófilo Otoni','Capelinha','Almenara','Diamantina','Araçuaí','Pedra Azul','Águas Formosas','Chapada do Norte','Jequitinhonha','Itaobim')
      OR C.NOMECID IN ('Governador Valadares','Guanhães','Mantena','Aimorés-Resplendor','Conselheiro Pena','Peçanha')
      OR C.NOMECID IN ('Ipatinga','Caratinga','João Monlevade','Coronel Fabriciano','Timóteo','Santana do Paraíso','Ipaba','Bom Jesus do Galho','Belo Oriente','Tarumirim','Inhapim','Nova Era')
      OR C.NOMECID IN ('Juiz de Fora','Manhuaçu','Ubá','Ponte Nova','Muriaé','Cataguases','Viçosa','Carangola','São João Nepomuceno','Bicas','Além Paraíba','Barbacena','Conselheiro Lafaiete','São João del Rei')
      OR C.NOMECID IN ('Varginha','Passos','Alfenas','Lavras','Guaxupé','Três Corações','Três Pontas','Boa Esperança','São Sebastião do Paraíso','Campo Belo','Piumhi','Nepomuceno')
      OR C.NOMECID IN ('Pouso Alegre','Poços de Caldas','Itajubá','São Lourenço','Caxambu','Baependi','Ouro Fino')
      OR C.NOMECID IN ('Uberaba','Araxá','Frutal','Iturama','Sacramento')
      OR C.NOMECID IN ('Uberlândia','Ituiutaba','Monte Carmelo','Araguari')
      OR C.NOMECID IN ('Patos de Minas','Unaí','Patrocínio')
      OR C.NOMECID IN ('Divinópolis','Formiga','Dores do Indaiá','Pará de Minas','Oliveira','Abaeté','Conselheiro Lafaiete')
    )
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

<script>
// -------------------- 1) Valores da query --------------------
const valoresBrutos = {
  <c:forEach var="linha" items="${lista.rows}" varStatus="st">
    "${linha.REGIAO}": "${linha.TOTAL_VENDAS}"<c:if test="${!st.last}">,</c:if>
  </c:forEach>
};

// normaliza (acentos, caixa, espaços) e cria aliases GV↔Governador Valadares, BH↔Belo Horizonte
const valoresIndex = {};
function normalizeKey(s){
  return String(s)
    .toLowerCase()
    .normalize('NFD').replace(/[\u0300-\u036f]/g,'') // remove acentos
    .replace(/\s+/g,' ').trim();
}
function aliasKey(s){
  s = normalizeKey(s);
  s = s.replace('regiao de belo horizonte', 'regiao de bh');
  s = s.replace('regiao de governador valadares', 'regiao de gv');
  return s;
}
// converte para número e indexa pela chave normalizada
for (const [k,v] of Object.entries(valoresBrutos)) {
  const n = typeof v === 'string' ? Number(v.replace(/\./g,'').replace(',','.')) : Number(v);
  valoresIndex[aliasKey(k)] = isNaN(n) ? 0 : n;
}

const fmt = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' });

// -------------------- 2) Mapa --------------------
const map = L.map('map', { center: [-18.5, -44], zoom: 6, minZoom: 6, maxZoom: 12 });
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { maxZoom: 19 }).addTo(map);

let geojson; // será preenchido após o fetch

// carrega o GeoJSON a partir do JSP (UTF-8)
fetch("${BASE_FOLDER}/Mapa/map_geo.jsp")
  .then(res => res.json())
  .then(data => {
    geojson = L.geoJSON(data, { style, onEachFeature }).addTo(map);
    map.fitBounds(geojson.getBounds(), { padding: [20,20] });
  })
  .catch(err => console.error("Erro carregando GeoJSON:", err));

// -------------------- 3) Funções de estilo e interação --------------------
function getRegionName(props) {
  return (props && props.name) ? props.name : 'Região';
}

// usa as cores do próprio GeoJSON (se existirem)
function style(feature) {
  const p = feature.properties || {};
  return {
    color: p.stroke || '#333',
    weight: +(p['stroke-width'] ?? 2),
    opacity: +(p['stroke-opacity'] ?? 1),
    fillColor: p.fill || '#ACAF50',
    fillOpacity: +(p['fill-opacity'] ?? 0.65)
  };
}

function onEachFeature(feature, layer) {
  const name = getRegionName(feature.properties);

  // label central
  layer.bindTooltip(name.replace(/^Regi[aã]o de\s*/i, ''), {
    permanent: true, direction: 'center', className: 'region-label'
  });

  // valor da query (com normalização + alias)
  const valor = valoresIndex[aliasKey(name)];
  const conteudo = `<b>${name}</b>` + (
    valor != null && !isNaN(valor) ? `<br/>Vendas: ${fmt.format(valor)}` : `<br/><i>Sem vendas no período</i>`
  );
  layer.bindPopup(conteudo);

  // highlight
  layer.on('mouseover', e => e.target.setStyle({ weight: 4, color: '#000' }));
  layer.on('mouseout',  e => geojson.resetStyle(e.target));
}
</script>
</body>
</html>
