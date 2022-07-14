package org.cyberark.conjur.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class VulnerableController {

    @Autowired
    private DataSourceProperties dataSourceProperties;

  @GetMapping("/vulnerable")
  ResponseEntity<?> getEnvironment() {
      StringBuilder sb = new StringBuilder();
      sb.append("DB URL =" + dataSourceProperties.getUrl() +"\n");
      sb.append("DB USERNAME = " + dataSourceProperties.getUsername()+"\n");
      sb.append("DB PASSWORD = " + dataSourceProperties.getPassword());
      return ResponseEntity.ok().body(sb.toString());
  }
}
