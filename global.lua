function collide(actor1, actor2)
    if actor1 == actor2 then
        return false
    end

    local x, y, w, h = actor1:getBoundingBox()
    local x2, y2 = x + w, y + h

    local a =
        isWithinBox(x, y, actor2:getBoundingBox()) or isWithinBox(x, y2, actor2:getBoundingBox()) or
        isWithinBox(x2, y, actor2:getBoundingBox()) or
        isWithinBox(x2, y2, actor2:getBoundingBox())

    local x, y, w, h = actor2:getBoundingBox()
    local x2, y2 = x + w, y + h

    local b =
        isWithinBox(x, y, actor1:getBoundingBox()) or isWithinBox(x, y2, actor1:getBoundingBox()) or
        isWithinBox(x2, y, actor1:getBoundingBox()) or
        isWithinBox(x2, y2, actor1:getBoundingBox())

    return a or b
end
