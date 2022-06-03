#include <tgbot/tgbot.h>
#include <cstdlib>

using namespace std::string_literals;

int main() {
    TgBot::Bot bot(getenv("token"));
    std::cout << "Bot created" << std::endl;

    bot.getEvents().onCommand("start"s, [&bot](TgBot::Message::Ptr message) {
        bot.getApi().sendMessage(message->chat->id, "Hi"s);
    });

    try {
        printf("Bot username: %s\n", bot.getApi().getMe()->username.c_str());
        TgBot::TgLongPoll longPoll(bot);
        while (true) {
            longPoll.start();
        }
    } catch (TgBot::TgException& e) {
        printf("error: %s\n", e.what());
    }
    return 0;
}