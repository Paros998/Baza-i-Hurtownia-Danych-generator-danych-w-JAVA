package pg.utils;

import lombok.experimental.UtilityClass;

import java.util.List;

@UtilityClass
public class ListUtil {
    public String getCsvArray(final List<String> list) {
        return list.toString().replace(",", ";").replace("[", "").replace("]", "");
    }
}
