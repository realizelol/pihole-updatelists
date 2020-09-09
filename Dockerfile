FROM pihole/pihole:latest

# START - jacklul/pihole - pihole-updatelists script #
COPY install.sh pihole-updatelists.* /tmp/pihole-updatelists/

RUN apt-get update && \
    apt-get install -Vy php-cli php-sqlite3 php-intl php-curl && \
    apt-get clean && \
    rm -fr /var/cache/apt/* /var/lib/apt/lists/*.lz4

RUN chmod +x /tmp/pihole-updatelists/install.sh && \
    bash /tmp/pihole-updatelists/install.sh && \
    rm -fr /tmp/pihole-updatelists
# END - jacklul/pihole - pihole-updatelists script #

# START - devonkupiec/pihole-unbound - pihole + unbound #
RUN \
	apt-get update && \
	apt-get install apt-utils unbound wget curl -y && \
	wget -q -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.root && \
	cp /usr/share/dns/root.key /var/lib/unbound/ && \
	mkdir -p /etc/services.d/unbound && \
	mkdir -p /etc/unbound/unbound.conf.d && \
	mkdir -p /var/log/unbound && \
	touch /var/log/unbound/unbound.log

ADD	unbound_service/* /etc/services.d/unbound/

COPY unbound_default_config/* /etc/unbound/unbound.conf.d/
# END - devonkupiec/pihole-unbound - pihole + unbound #
