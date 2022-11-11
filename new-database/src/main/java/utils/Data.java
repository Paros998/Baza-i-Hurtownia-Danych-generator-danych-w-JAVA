package utils;

import lombok.experimental.UtilityClass;

import com.google.gson.Gson;
import data.types.Country;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@UtilityClass
public class Data {
    public final String SCHEMA = "dbo";
    public final String RESOURCE_DIRECTORY = "classpath:example-data/";
    public final List<Country> countries;
    private final JSONParser jsonParser = new JSONParser();

    static {
        try {
            countries = loadResources(RESOURCE_DIRECTORY + Country.FILE);
        } catch (IOException | ParseException e) {
            throw new RuntimeException(e);
        }
    }

    @SuppressWarnings("unchecked")
    private <T> List<T> loadResources(final String fileLocation) throws IOException, ParseException {
        List<T> res = new ArrayList<>();

        FileReader fileReader = new FileReader(fileLocation);

        Object object = jsonParser.parse(fileReader);

        JSONArray resourceList = (JSONArray) object;

        Gson gson = new Gson();

        res = gson.fromJson(resourceList.toString(), res.getClass());
        return res;
    }
}