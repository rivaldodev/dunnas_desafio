package com.dunnas.web;

import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

/** Utility for JSTL function style formatting of OffsetDateTime. */
public final class JstlDates {
    private static final ZoneId ZONE = ZoneId.of("America/Sao_Paulo");
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").withZone(ZONE);

    private JstlDates() {}

    public static String format(OffsetDateTime odt) {
        if (odt == null) return "";
        return FORMATTER.format(odt.atZoneSameInstant(ZONE));
    }
}
