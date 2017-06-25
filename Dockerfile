FROM consul:0.8.4

COPY go/bin/counselor/counselor /bin/counselor

ENV CONSUL_LOCAL_CONFIG '{"skip_leave_on_interrupt": true}'

ENTRYPOINT ["counselor", "run", "--debug", "--verbose", "--"]
CMD ["docker-entrypoint.sh", "agent", "-server", "-ui", "-bind=0.0.0.0", "-client=0.0.0.0", "-advertise={{.LocalIpv4}}", "-retry-join={{.LocalIpv4}}", "-bootstrap-expect=1"]
