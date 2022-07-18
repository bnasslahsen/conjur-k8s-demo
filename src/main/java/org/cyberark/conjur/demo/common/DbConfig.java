package org.cyberark.conjur.demo.common;

import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;
import com.cyberark.conjur.springboot.annotations.ConjurValue;

/**
 * @author bnasslahsen
 */
@Profile("conjur")
@Primary
@Configuration(proxyBeanMethods=false)
@ConfigurationProperties(prefix = "spring.datasource")
public class DbConfig extends DataSourceProperties {

    @ConjurValue(key="secrets/test-app/url")
    private byte[] url;
    @ConjurValue(key="secrets/test-app/username")
    private byte[] username;
    @ConjurValue(key="secrets/test-app/password")
    private byte[] password;

    @Override
    public void afterPropertiesSet() throws Exception {
        super.afterPropertiesSet();
        this.setUrl(new String(url));
        this.setUsername(new String(username));
        this.setPassword(new String(password));
    }
}