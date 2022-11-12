package pg.utils;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@NoArgsConstructor(access = AccessLevel.PRIVATE)
public abstract class FileUtil {

    protected static File loadResourceFile(final String fileLocation) {
        URL resource = FileUtil.class.getClassLoader().getResource(fileLocation);
        assert resource != null;

        try {
            return new File(resource.toURI());
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    protected static File loadFile(final String fileLocation) {
        Path path = Paths.get(fileLocation);
        return new File(path.toUri());
    }

    protected static File createFile(final String fileLocation) {
        Path path = Paths.get(fileLocation);
        try {
            Files.createDirectories(path.getParent());
            File file = new File(path.toUri());
            if (file.exists())
                file.delete();
            file.createNewFile();
            return file;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
