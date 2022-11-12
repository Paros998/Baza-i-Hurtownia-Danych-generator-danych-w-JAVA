package pg.utils;

import lombok.NonNull;
import lombok.experimental.UtilityClass;

import java.io.File;
import java.lang.reflect.Field;

import static pg.utils.FileUtil.loadResourceFile;

@UtilityClass
public class JsonLoader {
    public static final String RESOURCE_DIRECTORY = "example-data/";

    public <T> File getData(final Class<T> clazz) {
        File file;
        try {
            Field field = clazz.getDeclaredField("FILE");
            file = loadResourceFile(RESOURCE_DIRECTORY + field.get(null));
        } catch (NoSuchFieldException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
        return file;
    }

    public <T> File getData(final @NonNull String fileName) {
        File file;
        file = loadResourceFile(RESOURCE_DIRECTORY + fileName);
        return file;
    }
}
