import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@SpringBootApplication
@EnableWebSocket
@EnableWebSocketMessageBroker
public class LiveRecordApplication {

    public static void main(String[] args) {
        SpringApplication.run(LiveRecordApplication.class, args);
    }

    @RestController
    public static class RecordController {

        private final Map<String, List<List<Float>>> values = new HashMap<>();

        @GetMapping("/")
        public String helloWorld() {
            return "TEST";
        }

        @MessageMapping("/connect")
        @SendTo("/topic/fullPayload")
        public Map<String, List<List<Float>>> handleConnect() {
            return values;
        }

        @Controller
        public class WebSocketConfig implements WebSocketConfigurer {
            
            @Override
            public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
                registry.addHandler(new RecordWebSocketHandler(values), "/socket")
                        .addInterceptors(new HttpSessionHandshakeInterceptor())
                        .setAllowedOrigins("*");
            }
        }
    }

    public static class RecordWebSocketHandler extends TextWebSocketHandler {

        private final Map<String, List<List<Float>>> values;

        public RecordWebSocketHandler(Map<String, List<List<Float>>> values) {
            this.values = values;
        }

        @Override
        protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
            // Handle incoming WebSocket messages here if needed
        }

        @Override
        public void afterConnectionEstablished(WebSocketSession session) throws Exception {
            session.sendMessage(new TextMessage(new ObjectMapper().writeValueAsString(values)));
        }
    }
}
