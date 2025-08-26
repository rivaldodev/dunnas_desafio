package com.dunnas.security;

import org.springframework.stereotype.Component;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class PrivateDescriptionPermissionCache {
    private final ConcurrentHashMap<String, Boolean> allowed = new ConcurrentHashMap<>();

    private String key(Long userId, Long obraId){ return userId+":"+obraId; }

    public boolean has(Long userId, Long obraId){
        return allowed.containsKey(key(userId, obraId));
    }

    public void grant(Long userId, Long obraId){
        allowed.put(key(userId, obraId), Boolean.TRUE);
    }

    public void revoke(Long userId, Long obraId){
        allowed.remove(key(userId, obraId));
    }

    public void revokeAllForUser(Long userId){
        String prefix = userId+":";
        allowed.keySet().removeIf(k -> k.startsWith(prefix));
    }
}