FROM consul:0.7.3

COPY go/bin/counselor/counselor /bin/counselor

ENV CONSUL_LOCAL_CONFIG '{"skip_leave_on_interrupt": true}'

ENTRYPOINT ["counselor", "run", "--debug", "--verbose", "--"]
CMD ["docker-entrypoint.sh", "agent", "-server", "-bootstrap-expect", "1", "-advertise", "{{.LocalIpv4}}", "{{.environment.EC2_TAG}}"]
