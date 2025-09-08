<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  java.io.InputStream is = application.getResourceAsStream("/Mapa/map.geojson");
  if (is != null) {
    java.util.Scanner s = new java.util.Scanner(is, "UTF-8").useDelimiter("\\A");
    out.print(s.hasNext() ? s.next() : "{}");
    s.close();
  } else {
    out.print("{}");
  }
%>
