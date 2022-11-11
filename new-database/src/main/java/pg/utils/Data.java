package pg.utils;

import lombok.Getter;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import pg.types.Country;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Field;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.Collections;
import java.util.List;

@Getter
public class Data {
    public static final String SCHEMA = "dbo";
    public static final String RESOURCE_DIRECTORY = "example-data/";
    public final ObjectMapper objectMapper = new ObjectMapper();
    private List<Country> countries;

    public Data() {
        readCountries();
    }

    private void readCountries() {
        try {
            countries = objectMapper.readValue(getData(Country.class), new TypeReference<List<Country>>() {
            });
        } catch (IOException e) {
            countries = Collections.emptyList();
        }
    }

    @SuppressWarnings("unchecked")
    private <T> File getData(Class<T> clazz) {
        File file;
        try {
            Field field = clazz.getDeclaredField("FILE");
            file = loadResources(RESOURCE_DIRECTORY + field.get(null));
        } catch (NoSuchFieldException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
        return file;
    }

    private File loadResources(final String fileLocation) {
        URL resource = getClass().getClassLoader().getResource(fileLocation);
        assert resource != null;

        try {
            return new File(resource.toURI());
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }
}