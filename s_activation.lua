local activation
local used

local link = "athenadev"

function activationKey(pl, cmd, key)
    if not key then exports["notification"]:addNotification(pl, "/key [KEY]", "info") return end
    if key == tostring(activation) then
        if used == 1 then exports["notification"]:addNotification(pl, "Girdiğiniz aktivasyon kodu başkası tarafından kullanılmış.", "error") return end
        exports["notification"]:addNotification(pl, "Başarıyla aktivasyon kodunu girdiniz ve ödülü kazandınız.", "success")
        setTimer(function()        
            exports["infobox"]:addBox(pl, "success", "Hesabınıza 5 TL OOC bakiye eklendi.")
            used = 1
            local currentMoney = getElementData(pl, "bakiyeMiktar") or 0
            setElementData(pl, "bakiyeMiktar", currentMoney+5)
            local query = dbExec(exports.mysql:getConnection(), "UPDATE accounts SET bakiyeMiktar='"..tonumber(currentMoney+5).."' WHERE id ='"..(getElementData(pl, "account:id")).."'")
            if not query then
                outputChatBox("Bilinmeyen bir hata oluştu, 'discord.gg/"..link.."' adresinden bize ulaşın.", pl, 255, 0, 0, true)
            end
        end, 1500, 1)
    elseif activation == null then
        exports["notification"]:addNotification(pl, "Aktif bir aktivasyon kodu bulunmamakta.", "error")
    else
        exports["notification"]:addNotification(pl, "Girdiğiniz kod değiştirilmiş yada hatalı.", "info")
    end
end
addCommandHandler("key", activationKey)

function addNewActivation(pl, cmd)
    if cmd then
        if getElementData(pl, "admin_level") >= 10 then
            activation = math.random(111111, 999999)
			used = 0
            outputChatBox("[!] #FFFFFFBaşarıyla aktivasyon kodu oluşturuldu. ("..activation..")", pl, 0, 119, 255, true)
        else
            exports["notification"]:addNotification(pl, "Bunu yapmak için yetkin yok.", "error")
        end
    end
end
addCommandHandler("addkey", addNewActivation)

function currentActivation(pl, cmd)
    if cmd then
        if getElementData(pl, "admin_level") >= 10 then
			if activation == null then exports["notification"]:addNotification(pl, "Aktif bir aktivasyon kodu bulunmamakta.", "error") return end
            if used == 1 then
                outputChatBox("[!] #FFFFFFAktivasyon kodu : "..activation.." #00FF00[KULLANILMIŞ]", pl, 0, 119, 255, true)
            else
                outputChatBox("[!] #FFFFFFAktivasyon kodu : "..activation.." #FF0000[KULLANILMAMIŞ]", pl, 0, 119, 255, true)
            end
        else
            exports["notification"]:addNotification(pl, "Bunu yapmak için yetkin yok.", "error")
        end
    end
end
addCommandHandler("currentkey", currentActivation)